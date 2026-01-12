pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool isRecording: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: checkRecordingStatus.running = true
    }

    Process {
        id: checkRecordingStatus
        command: ["pgrep", "-x", "wf-recorder"]

        onExited: (exitCode, exitStatus) => {
            root.isRecording = (exitCode === 0);
        }
    }

    Component.onCompleted: {
        checkRecordingStatus.running = true;
    }
}
