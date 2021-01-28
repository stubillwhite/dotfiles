"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Rename = void 0;
class Rename {
    constructor() {
        this.command = "editor.action.rename";
        this.when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
        this.keysDefault = [
            new VSCodeKeyDefault("Linux", ["f2"]),
            new VSCodeKeyDefault("Mac", ["f2"]),
            new VSCodeKeyDefault("Windows", ["f2"]),
        ];
    }
}
exports.Rename = Rename;
/*
{
    "key": "f2",
    "command": "editor.action.rename",
    "when": "editorHasRenameProvider && editorTextFocus && !editorReadonly"
}
*/ 
//# sourceMappingURL=Rename.js.map