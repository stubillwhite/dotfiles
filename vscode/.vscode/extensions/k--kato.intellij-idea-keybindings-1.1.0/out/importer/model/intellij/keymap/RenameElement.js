"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RenameElement = void 0;
const IntelliJKeystrokeDefault_1 = require("../IntelliJKeystrokeDefault");
class RenameElement {
    constructor() {
        this.actionId = 'RenameElement';
        this.keystrokesDefault = [
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault('Linux', 'shift f6'),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault('Mac', 'shift f6'),
            new IntelliJKeystrokeDefault_1.IntelliJKeystrokeDefault('Windows', 'shift f6'),
        ];
    }
}
exports.RenameElement = RenameElement;
//# sourceMappingURL=RenameElement.js.map