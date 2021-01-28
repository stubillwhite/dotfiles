"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.IntelliJ2VSCodeGenerator = void 0;
const CodeCompletion_1 = require("./model/intellij/keymap/CodeCompletion");
class IntelliJ2VSCodeGenerator {
    all(os) {
        const keybindings = [
            new CodeCompletion_1.CodeCompletion(),
        ];
        return "";
    }
    static toVSCodeKeybinding(keybind) {
    }
}
exports.IntelliJ2VSCodeGenerator = IntelliJ2VSCodeGenerator;
//# sourceMappingURL=IntelliJ2VSCodeGenerator.js.map