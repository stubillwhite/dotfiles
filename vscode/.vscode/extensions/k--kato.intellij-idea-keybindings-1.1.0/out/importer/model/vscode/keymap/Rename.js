"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Rename = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class Rename {
    constructor() {
        this.command = 'editor.action.rename';
        this.when = 'editorHasRenameProvider && editorTextFocus && !editorReadonly';
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault('Linux', 'f2'),
            new VSCodeKeyDefault_1.VSCodeKeyDefault('Mac', 'f2'),
            new VSCodeKeyDefault_1.VSCodeKeyDefault('Windows', 'f2'),
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