"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Rename = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class Rename {
    constructor() {
        this.command = "workbench.action.terminal.focus";
        this.when = "!terminalFocus";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", ["alt+f12"]),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", ["alt+f12"]),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", ["alt+f12"]),
        ];
    }
}
exports.Rename = Rename;
//# sourceMappingURL=TerminalForcus.js.map