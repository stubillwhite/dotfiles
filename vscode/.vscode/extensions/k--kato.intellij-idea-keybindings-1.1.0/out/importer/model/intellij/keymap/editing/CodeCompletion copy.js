"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CodeCompletion = void 0;
const IntelliJKeystrokeDefault_1 = require("../../IntelliJKeystrokeDefault");
class CodeCompletion {
    constructor() {
        this.actionId = "CodeCompletion";
        this.keystrokesDefault = [
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Linux", "ctrl space"),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Mac", "ctrl space"),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Windows", "ctrl space"),
        ];
    }
}
exports.CodeCompletion = CodeCompletion;
//# sourceMappingURL=CodeCompletion%20copy.js.map