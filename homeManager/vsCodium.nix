{pkgs, ...}: 

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
            yzhang.markdown-all-in-one
            bbenoist.nix
            christian-kohler.path-intellisense
            vscode-icons-team.vscode-icons
        ];

        keybindings = [
            {
                key = "shift+alt+down";
                command = "editor.action.copyLinesDownAction";
                when = "editorTextFocus && !editorReadonly";
            }
            {
                key = "shift+alt+up";
                command = "editor.action.copyLinesUpAction";
                when = "editorTextFocus && !editorReadonly";
            }
        ];
    };
}