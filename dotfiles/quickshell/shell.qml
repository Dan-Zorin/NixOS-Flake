import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // Theme colors
    property color colBg: "#1a1b26"
    property color colBgAlpha: "#cc1a1b26"  // Semi-transparent background
    property color colBubble: "#2a2b36"     // Bubble background
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    // Font
    property string fontFamily: "BlexMono Nerd Font"
    property int fontSize: 15

    // System info properties
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0
    property string currentLayout: "Tile"

    // Weather properties
    property string weatherEmoji: "🌡"
    property string temperature: "--°C"

    // CPU frequency
    Process {
        id: cpuProc
        command: ["sh", "-c", "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | awk '{printf \"%.2f\\n\", $1/10000}'"]
        stdout: SplitParser {
            onRead: data => cpuUsage = parseFloat(data)
        }
        Component.onCompleted: running = true
    }

    // Memory usage
    Process {
        id: memProc
        command: ["sh", "-c", "awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf \"%.1f\", (total-avail)/1024/1024}' /proc/meminfo"]
        stdout: SplitParser {
            onRead: data => memUsage = parseFloat(data)
        }
        Component.onCompleted: running = true
    }

    // Disk usage
    Process {
        id: diskProc
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var percentStr = parts[4] || "0%"
                diskUsage = parseInt(percentStr.replace('%', '')) || 0
            }
        }
        Component.onCompleted: running = true
    }

    // Weather
    Process {
        id: weatherProc
        command: ["sh", "-c", "curl -s 'http://api.openweathermap.org/data/2.5/weather?id=3714637&units=metric&appid=50dfe3c4af787e95cfb00325885f0019' | jq -r '.weather[0].main + \",\" + (.main.temp|tostring)'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(",")
                var condition = parts[0].toLowerCase()
                var temp = parts[1] || "--"

                if (condition.includes("clear")) root.weatherEmoji = "☀️"
                else if (condition.includes("cloud")) root.weatherEmoji = "☁️"
                else if (condition.includes("rain")) root.weatherEmoji = "🌧️"
                else if (condition.includes("snow")) root.weatherEmoji = "❄️"
                else if (condition.includes("storm")) root.weatherEmoji = "⛈️"
                else root.weatherEmoji = "🌡"

                root.temperature = temp + "°C"
            }
        }
        Component.onCompleted: running = true
    }

    // Volume level
    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    volumeLevel = Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Current layout
    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    currentLayout = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    // System stats timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            diskProc.running = true
            volProc.running = true
        }
    }

    // Weather timer
    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: weatherProc.running = true
    }

    // Layout updates
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            layoutProc.running = true
        }
    }

    // Reusable bubble component
    component InfoBubble: Rectangle {
        property alias text: bubbleText.text
        property alias textColor: bubbleText.color

        Layout.preferredHeight: 22
        color: root.colBubble
        radius: 11

        Text {
            id: bubbleText
            anchors.centerIn: parent
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            leftPadding: 10
            rightPadding: 10
        }

        Layout.preferredWidth: bubbleText.contentWidth + 20
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 34
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                color: root.colBgAlpha
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 8

                    // LEFT SECTION
                    RowLayout {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 8

                        // Logo
                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            color: "transparent"

                            Image {
                                anchors.fill: parent
                                source: "file:///home/zorin/.config/quickshell/icons/tonybtw.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        // Workspaces
                        Repeater {
                            model: 9

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 24
                                color: "transparent"

                                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                                property bool hasWindows: workspace !== null

                                Text {
                                    text: " "
                                    color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                                    font.pixelSize: root.fontSize
                                    font.family: "Font Awesome 6 Free Solid"
                                    font.bold: true
                                    anchors.centerIn: parent
                                }

                                Rectangle {
                                    width: 20
                                    height: 3
                                    color: parent.isActive ? root.colPurple : "transparent"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    radius: 1.5
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                                }
                            }
                        }

                        // Layout indicator
                        InfoBubble {
                            text: currentLayout
                            textColor: root.colYellow
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // CENTER SECTION - Clock
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 24
                        color: root.colBubble
                        radius: 12

                        Text {
                            id: clockText
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(new Date(), "HH:mm AP")
                            color: root.colPurple
                            font.pixelSize: root.fontSize + 1
                            font.family: root.fontFamily
                            font.bold: true
                            leftPadding: 14
                            rightPadding: 14
                        }

                        width: clockText.contentWidth + 28

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm AP")
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // RIGHT SECTION - System info
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 6

                        // System Tray
                        Repeater {
                            model: SystemTray.items

                            Rectangle {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                color: root.colBubble
                                radius: 12

                                required property var modelData

                                Image {
                                    id: trayIcon
                                    anchors.centerIn: parent
                                    width: 18
                                    height: 18
                                    source: modelData.icon?.toString() ?? ""
                                    smooth: true
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                    hoverEnabled: true

                                    onClicked: mouse => {
                                        if (mouse.button === Qt.LeftButton) {
                                            modelData.activate()
                                        } else if (mouse.button === Qt.RightButton) {
                                            modelData.menu?.open()
                                        } else if (mouse.button === Qt.MiddleButton) {
                                            modelData.secondaryActivate()
                                        }
                                    }
                                }
                            }
                        }

                        InfoBubble {
                            text: " " + memUsage.toFixed(1) + "GB"
                            textColor: root.colYellow
                        }

                        InfoBubble {
                            text: " " + cpuUsage.toFixed(2) + "GHz"
                            textColor: root.colCyan
                        }

                        InfoBubble {
                            text: root.weatherEmoji + " " + root.temperature
                            textColor: root.colBlue
                        }

                        InfoBubble {
                            text: "󰕾 " + volumeLevel + "%"
                            textColor: root.colPurple
                        }

                        InfoBubble {
                            text: Qt.formatDateTime(new Date(), "dd/MM/yy")
                            textColor: root.colCyan
                        }
                    }
                }
            }
        }
    }
}