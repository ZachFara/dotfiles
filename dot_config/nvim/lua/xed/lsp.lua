-- print("Hello from lsp.lua")

local log = vim.log.levels
local has_new_lsp_config = vim.fn.has('nvim-0.11') == 1

local function safe_require(name, opts)
    local ok, mod = pcall(require, name)
    if not ok then
        if not (opts and opts.silent) then
            vim.notify(string.format("[xed] Unable to load %s", name), log.WARN)
        end
        return nil
    end
    return mod
end

local mason = safe_require('mason')
if mason then
    mason.setup()
end

local mason_lspconfig = safe_require('mason-lspconfig')
if mason_lspconfig then
    mason_lspconfig.setup({
        ensure_installed = { "jedi_language_server", "lua_ls", "pyright" },
    })
end

local legacy_lspconfig = nil
if not has_new_lsp_config then
    legacy_lspconfig = safe_require('lspconfig')
    if not legacy_lspconfig then
        return
    end
end

local util = safe_require('lspconfig.util')
if not util and legacy_lspconfig then
    util = legacy_lspconfig.util
end
if not util then
    vim.notify('[xed] Unable to load lspconfig.util', log.ERROR)
    return
end

local cmp_nvim_lsp = safe_require('cmp_nvim_lsp', { silent = true })
local function get_capabilities()
    if cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
        return cmp_nvim_lsp.default_capabilities()
    end
    return vim.lsp.protocol.make_client_capabilities()
end

local function default_on_attach(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
end

local fn = vim.fn

local function get_python_path(root_dir)
    local virtual_env = os.getenv("VIRTUAL_ENV")
    if virtual_env and virtual_env ~= "" then
        local python = virtual_env .. "/bin/python"
        if fn.executable(python) == 1 then
            return python
        end
    end

    if root_dir and root_dir ~= "" then
        local candidates = {
            root_dir .. "/.venv/bin/python",
            root_dir .. "/venv/bin/python",
        }
        for _, candidate in ipairs(candidates) do
            if fn.executable(candidate) == 1 then
                return candidate
            end
        end
    end

    local exe = fn.exepath("python3")
    if exe ~= "" then
        return exe
    end

    exe = fn.exepath("python")
    if exe ~= "" then
        return exe
    end

    return "python3"
end

local function configure_server(name, config)
    if has_new_lsp_config then
        local ok, err = pcall(vim.lsp.config, name, config)
        if not ok then
            vim.notify(string.format('[xed] Failed to configure %s: %s', name, err), log.ERROR)
            return
        end
        local enabled, enable_err = pcall(vim.lsp.enable, name)
        if not enabled then
            vim.notify(string.format('[xed] Failed to enable %s: %s', name, enable_err), log.ERROR)
        end
        return
    end

    if not legacy_lspconfig then
        vim.notify('[xed] legacy lspconfig not available to configure servers', log.ERROR)
        return
    end

    local server = legacy_lspconfig[name]
    if not server then
        vim.notify(string.format('[xed] Server %s not available in legacy lspconfig', name), log.ERROR)
        return
    end
    server.setup(config)
end

local function normalize_fname(fname)
    if type(fname) == "number" then
        local bufname = vim.api.nvim_buf_get_name(fname)
        if bufname == "" then
            return nil
        end
        return bufname
    end
    if type(fname) ~= "string" or fname == "" then
        return nil
    end
    return fname
end

local function python_root_dir(fname)
    fname = normalize_fname(fname)
    if not fname then
        return nil
    end
    local root = util.find_git_ancestor(fname)
        or util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt')(fname)
        or util.path.dirname(fname)
    if root == vim.loop.os_homedir() then
        return nil
    end
    return root
end

configure_server('pyright', {
    on_attach = default_on_attach,
    root_dir = python_root_dir,
    before_init = function(_, config)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        local current = config.root_dir
        if not current or current == "" then
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname ~= "" then
                current = util.path.dirname(bufname)
            end
        end
        config.settings.python.pythonPath = get_python_path(current)
    end,
    capabilities = get_capabilities(),
    settings = {
        python = {},
    },
})

configure_server('lua_ls', {
    on_attach = default_on_attach,
    capabilities = get_capabilities(),
    root_dir = function(fname)
        fname = normalize_fname(fname)
        if not fname then
            return nil
        end
        local root = util.find_git_ancestor(fname)
            or util.root_pattern('.luarc.json', '.luacheckrc', '.stylua.toml', 'Makefile')(fname)
            or util.path.dirname(fname)
        if root == vim.loop.os_homedir() then
            return nil
        end
        return root
    end,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

local cmp = safe_require('cmp')
if cmp then
    local luasnip = safe_require('luasnip', { silent = true })
    cmp.setup({
        snippet = {
            expand = function(args)
                if not luasnip then
                    vim.notify("[xed] luasnip is not available for completion snippets", log.WARN)
                    return
                end
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-e>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
            { name = 'nvim_lsp' },
        },
    })
end
