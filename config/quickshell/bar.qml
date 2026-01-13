import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform 1.1 // for Process

// Adjust these colors to match your Qtile palette
readonly property color c_night: "#2E3440"
readonly property color c_dark:  "#3B4252"
readonly property color c_clear: "#000000"
readonly property color c_medium:"#434C5E"
readonly property color c_light: "#4C566A"
readonly property color c_sat:   "#8FBCBB"
readonly property color c_dim:   "#5E81AC"

Window {
    id: root
    visible: true
    flags: Qt.FramelessWindowHint
    width: Screen.width
    height: 36
    color: "transparent"

    // LayerShell / Quickshell will place this at top; if your runtime needs
    // special anchoring, add it to the Quickshell runtime invocation.

    Rectangle {
        id: bar
        anchors.top: parent.top
        width: parent.width
        height: parent.height
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Spacer left
            Rectangle {
                width: 10
                color: c_night
                Layout.preferredWidth: 10
            }

            // Logo segment
            PowerSegment {
                segmentColor: c_night
                content: Image { source: Qt.resolvedUrl("assets/logo.png"); height: 24; fillMode: Image.PreserveAspectFit }
            }

            // Workspaces (GroupBox equivalent)
            PowerSegment {
                segmentColor: c_dark
                content: Row {
                    spacing: 8
                    Repeater {
                        model: 9
                        Button {
                            id: wsBtn
                            property int idx: index + 1
                            text: (index+1).toString()
                            font.pixelSize: 14
                            background: Rectangle {
                                color: wsBtn.pressed ? c_sat : "transparent"
                                radius: 4
                            }
                            onClicked: {
                                // send workspace switch command: using hyprctl
                                // Quickshell runtime must allow shell exec. We use Process.
                                var p = Process {}
                                p.start("sh", ["-c", "hyprctl dispatch workspace " + (index+1)])
                            }
                        }
                    }
                }
            }

            // Layout Icon + Layout name
            PowerSegment {
                segmentColor: c_medium
                content: Row {
                    spacing: 8
                    Image { source: Qt.resolvedUrl("assets/layout-icon.svg"); height:20; visible: false } // optional
                    Text { id: layoutText; text: "RatioTile"; font.pixelSize: 14 }
                }
            }

            // Spacer and WindowName
            PowerSegment {
                segmentColor: c_light
                content: Text {
                    id: windowName
                    text: "---"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    width: 640
                }
            }

            // Filler to push right-side widgets
            Item { Layout.fillWidth: true }

            // Right side widgets (time, memory, cpu, weather, volume, date)
            PowerSegment { segmentColor: c_night; content: IconText { icon: "\uF017"; textBind: timeText } }
            PowerSegment { segmentColor: c_night; content: Text { id: timeText; text: Qt.formatTime(new Date(), "hh:mm AP"); font.pixelSize: 14 } }

            PowerSegment { segmentColor: c_night; content: Text { id: dateText; text: Qt.formatDate(new Date(), "dd/MM/yy"); font.pixelSize: 12 } }

            PowerSegment { segmentColor: c_medium; content: IconText { icon: "\uF001"; textBind: memText } } // memory icon
            PowerSegment { segmentColor: c_medium; content: Text { id: memText; text: "0.0G"; font.pixelSize: 13 } }

            PowerSegment { segmentColor: c_medium; content: IconText { icon: "\uF2DB"; textBind: cpuText } } // cpu icon
            PowerSegment { segmentColor: c_medium; content: Text { id: cpuText; text: "0.00GHz"; font.pixelSize: 13 } }

            PowerSegment { segmentColor: c_dark; content: IconText { icon: "\uF0C2"; textBind: weatherText } }
            PowerSegment { segmentColor: c_dark; content: Text { id: weatherText; text: "⛅ 0.0°"; font.pixelSize: 13 } }

            PowerSegment { segmentColor: c_dark; content: IconText { icon: "\uF028"; textBind: volText } }
            PowerSegment { segmentColor: c_dark; content: Text { id: volText; text: "0%"; font.pixelSize: 13 } }

            Rectangle {
                width: 10
                color: c_night
                Layout.preferredWidth: 10
            }
        }
    }

    // Timer to refresh time + external widget values
    Timer {
        id: refreshTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            // update time
            var d = new Date()
            timeText.text = Qt.formatTime(d, "hh:mm AP")
            dateText.text = Qt.formatDate(d, "dd/MM/yy")

            // run helper scripts and update text values asynchronously
            runScriptRead("~/.config/quickshell/scripts/memory.sh", function(output){ if(output) memText.text = output.trim() })
            runScriptRead("~/.config/quickshell/scripts/cpu.sh", function(output){ if(output) cpuText.text = output.trim() })
            runScriptRead("~/.config/quickshell/scripts/weather.sh", function(output){ if(output) weatherText.text = output.trim() })
            runScriptRead("~/.config/quickshell/scripts/volume.sh", function(output){ if(output) volText.text = output.trim() })
        }
    }

    // Helper: run script and callback with stdout
    function runScriptRead(scriptPath, callback) {
        var p = Process {}
        p.started.connect(function(){})
        p.readyReadStandardOutput.connect(function(){
            var data = p.readAllStandardOutput()
            var text = ""
            for(var i = 0; i < data.length; ++i) text += String.fromCharCode(data[i])
            callback(text)
        })
        p.finished.connect(function(code, status){})
        p.start("sh", ["-c", scriptPath])
    }
}

// Reusable component for powerline-like segment
Component {
    id: powerComponent
    Rectangle {
        property color segmentColor: "#333"
        property variant content: null
        height: parent.height
        color: segmentColor
        anchors.verticalCenter: parent.verticalCenter
        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8
            Item { width: 6 }
            Loader { sourceComponent: content; anchors.verticalCenter: parent.verticalCenter }
        }
        // Right triangulation to mimic PowerLine
        Canvas {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 20
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0,0,width,height)
                ctx.fillStyle = segmentColor
                ctx.beginPath()
                ctx.moveTo(0,0)
                ctx.lineTo(width, height/2)
                ctx.lineTo(0,height)
                ctx.closePath()
                ctx.fill()
            }
        }
    }
}

//// Inline component type alias to ease usage
pragma Singleton
QtObject { id: helper }



