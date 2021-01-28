"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OSPickerList = exports.WINDOWS_TO_WINDOWS = exports.WINDOWS_TO_MAC = exports.WINDOWS_TO_LINUX = exports.MAC_TO_WINDOWS = exports.MAC_TO_MAC = exports.MAC_TO_LINUX = void 0;
exports.MAC_TO_LINUX = {
    label: 'Mac to Linux',
    detail: 'Import from IntelliJ for macOS (XML), Export to VSCode for Linux (JSON)'
};
exports.MAC_TO_MAC = {
    label: 'Mac to Mac',
    detail: 'Import from IntelliJ for macOS (XML), Export to VSCode for macOS (JSON)'
};
exports.MAC_TO_WINDOWS = {
    label: 'Mac to Windows',
    detail: 'Import from IntelliJ for macOS (XML), Export to VSCode for Windows (JSON)'
};
exports.WINDOWS_TO_LINUX = {
    label: 'Windows to Linux',
    detail: 'Import from IntelliJ for Windows (XML), Export to VSCode for Linux (JSON)'
};
exports.WINDOWS_TO_MAC = {
    label: 'Windows to Mac',
    detail: 'Import from IntelliJ Windows (XML), Export to VSCode for macOS (JSON)'
};
exports.WINDOWS_TO_WINDOWS = {
    label: 'Windows to Windows',
    detail: 'Import from IntelliJ for Windows (XML), Export to VSCode for Windows (JSON)'
};
exports.OSPickerList = [
    exports.MAC_TO_LINUX, exports.MAC_TO_MAC, exports.MAC_TO_WINDOWS,
    exports.WINDOWS_TO_LINUX, exports.WINDOWS_TO_MAC, exports.WINDOWS_TO_WINDOWS,
];
//# sourceMappingURL=OS.js.map