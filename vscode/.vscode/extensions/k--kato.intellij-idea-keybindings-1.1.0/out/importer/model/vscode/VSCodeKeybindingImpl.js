"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeybindingImpl = void 0;
class VSCodeKeybindingImpl {
    constructor(key, command) {
        this.key = key.key;
        this.command = command.command;
        this.when = command.when;
    }
}
exports.VSCodeKeybindingImpl = VSCodeKeybindingImpl;
//# sourceMappingURL=VSCodeKeybindingImpl.js.map