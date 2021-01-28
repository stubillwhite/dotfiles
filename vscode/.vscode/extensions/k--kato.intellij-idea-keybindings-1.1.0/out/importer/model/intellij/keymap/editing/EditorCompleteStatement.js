"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EditorCompleteStatement = void 0;
const IntelliJKeystrokeDefault_1 = require("../../IntelliJKeystrokeDefault");
class EditorCompleteStatement {
    constructor() {
        this.actionId = "EditorCompleteStatement";
        this.keystrokesDefault = [
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Linux", "shift meta enter"),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Mac", "shift meta enter"),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault("Windows", "shift meta enter"),
        ];
    }
}
exports.EditorCompleteStatement = EditorCompleteStatement;
//# sourceMappingURL=EditorCompleteStatement.js.map