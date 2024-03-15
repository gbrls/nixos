{pkgs, ...}:
{
  programs.nixvim = {
    enable = true;
    plugins = {
      treesitter.enable = true;
      telescope.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      surround.enable = true;
      toggleterm = { enable = true; direction = "vertical"; size = 100; };
      lsp = {
        enable = true;
        servers.rust-analyzer = { enable = true; installRustc = false; installCargo = false; };
        servers.nil_ls.enable = true;
      };
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      nvim-cmp = {
        snippet.expand = "luasnip";
        enable = true;
        sources =
          [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<S-Tab>" = { action = "cmp.mapping.select_prev_item()"; modes = [ "i" "s" ]; };
          "<Tab>" = { action = "cmp.mapping.select_next_item()"; modes = [ "i" "s" ]; };
        };
      };
      rust-tools = {
        enable = true;
        reloadWorkspaceFromCargoToml = true;
        inlayHints = {
          auto = true;
        };
    };
    keymaps = [
      # Terminal
      { mode = "t"; action = ''[[<C-\><C-n>]]''; key = "<esc>"; lua = true; options.desc = "Terminal Escape remap"; }
      { action = "function() return require('toggleterm').toggle(0) end"; key = "<leader>ot"; lua = true; options.desc = "Open Terminal"; }

      # LSP
      { action = "vim.lsp.buf.hover"; key = "K"; lua = true; options.desc = "Hover"; }
      { action = "vim.lsp.buf.rename"; key = "<leader>lr"; lua = true; options.desc = "Rename"; } 
      { action = "vim.lsp.buf.code_action"; key = "<leader>la"; lua = true; options.desc = "Action"; }
      { action = "vim.lsp.buf.format"; key = "<leader>lf"; lua = true; options.desc = "Format Buffer"; }
      { action = "vim.lsp.buf.definition"; key = "gd"; lua = true; options.desc = "Go to Definition"; }
      # Telescope
      { action = "require('telescope.builtin').commands"; key = "<leader><leader>"; lua = true; options.desc = "All Commands"; }
      { action = "require('telescope.builtin').find_files"; key = "<leader>ff"; lua = true; options.desc = "Find Files"; }
      { action = "require('telescope.builtin').live_grep"; key = "<leader>fs"; lua = true; options.desc = "File Search"; }
      { action = "require('telescope.builtin').oldfiles"; key = "<leader>fh"; lua = true; options.desc = "File History"; }
      { action = "require('telescope.builtin').lsp_dynamic_workspace_symbols"; key = "<leader>ft"; lua = true; options.desc = "Tags"; }
      { action = "require('telescope.builtin').quickfix"; key = "<leader>q"; lua = true; options.desc = "Quickfixlist"; }
    ];
    colorschemes.melange.enable = true;
    globals.mapleader = " ";
    options = {
      number = true; relativenumber = true; scrolloff = 3;
      tabstop = 4; softtabstop = 4; shiftwidth = 4; expandtab = true;
      breakindent = true;
      ignorecase = true; smartcase = true;

    };
    clipboard.register = "unnamedplus";
    clipboard.providers.xclip.enable = true;
    autoCmd = [
      { event = "FileType"; pattern = "nix"; command = "setlocal tabstop=2 shiftwidth=2"; }
    ];
  };
}
