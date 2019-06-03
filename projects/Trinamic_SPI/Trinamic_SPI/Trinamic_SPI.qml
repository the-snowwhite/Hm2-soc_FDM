/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.Application 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0
import Machinekit.Application.Controls 1.0
import "./Controls"
import "./ManualTab"
import "./StatusBar"

//HalApplicationWindow {
ServiceWindow {
    id: root

    property bool wasConnected: false
    property string labelName: "SG"
    property double gaugeZ0BorderValue: 50.0
//     property double spinMinimumValue: minTemperaturePin.value
//     property double spinMaximumValue: maxTemperaturePin.value
    property double spinMinimumValue: -64
    property double spinMaximumValue: 63
//    property double gaugeMinimumValue: spinMinimumValue
//    property double gaugeMaximumValue: spinMaximumValue * 1.1
    property double gaugeMinimumValue: -512
    property double gaugeMaximumValue: 512
    property double gaugeZ1BorderValue: gaugeMaximumValue * 0.9
    property double lastSgtValue

//    name: "TrinamicSPI"
//    title: qsTr("Trinamic SPI Test")
    title: applicationCore.applicationName + (d.machineName === "" ? "" :" - " +  d.machineName)

    statusBar:applicationStatusBar
    toolBar: applicationToolBar
//    menuBar: applicationMenuBar

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Loader {
                id: applicationToolBar
                source: "ApplicationToolBar.qml"
                active: true
        }

        Service {
            id: halrcompService
            type: "halrcomp"
        }

        Service {
            id: halrcmdService
            type: "halrcmd"
        }

        ApplicationCore {
            id: applicationCore
            notifications: applicationNotifications
            applicationName: "Trinamic-SPI"
        }


        visible: halRemoteComponent.ready || wasConnected
        enabled:  halRemoteComponent.connected

        HalRemoteComponent {
            id: halRemoteComponent
            halrcmdUri: halrcmdService.uri
            halrcompUri: halrcompService.uri
            ready: (halrcmdService.ready && halrcompService.ready) || connected
            name: "TrinamicSPI"
            containerItem: root
            create: false
            onErrorStringChanged: console.log(errorString)
            onConnectedChanged: root.wasConnected = true
        }

        RowLayout {
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                Label {
                    id: sgtSetLabel
                    font.bold: true
                    text: root.labelName
                }

                Item {
                    Layout.fillWidth: true
                }

                HalLed {
                    id: errorLed
                    name: "error"
                    onColor: "red"
                    Layout.preferredHeight: sgtSetLabel.height * 0.9
                    Layout.preferredWidth: sgtSetLabel.height * 0.9
                }
            }
        }

        ColumnLayout {
            id: transport
            ApplicationStatusBar { id: applicationStatusBar }
                //       ApplicationMenuBar { id: applicationMenuBar }

            RowLayout {
                Layout.fillWidth: true


                Label {
                    text: qsTr("Axis")
                }

                Item {
                    Layout.fillWidth: true
                }

                AxisRadioGroup {
                    id: axisRadioGroup
                    Layout.fillWidth: false
                }
            }

            RowLayout {
                Layout.fillWidth: true

                JogButton {
                    id: decrementButton
                    Layout.fillWidth: false
                    direction: -1
                    distance: jogCombo.distance
                    axis: axisRadioGroup.axis
                    checkable: true
                }

                JogButton {
                    id: incrementButton
                    Layout.fillWidth: false
                    direction: 1
                    distance: jogCombo.distance
                    axis: axisRadioGroup.axis
                    checkable: true
                }

                JogDistanceComboBox {
                    id: jogCombo
                    Layout.fillWidth: true
                    axis: axisRadioGroup.axis
                }

                KeyboardJogControl {
                    id: keyboardJogControl
                    enabled: jogCombo.distance !== 0.0
                    onSelectAxis: axisRadioGroup.axis = axis
                    onIncrement: incrementButton._toggle(enabled)
                    onDecrement: decrementButton._toggle(enabled)
                    onSelectIncrement: {
                        if (jogCombo.currentIndex == 0) {
                            jogCombo.currentIndex = index;
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: false

                Label {
                    text: qsTr("Jog Velocity")
                }
                Item {
                    Layout.fillWidth: true
                }

                Label {
//                        text: jogVelocitySlider.displayValue.toFixed(1) + " " + jogVelocitySlider.units
                    text: jogVelocitySlider.displayValue.toFixed(1) + " " + "rev/min"
                }
            }

            JogVelocitySlider {
                id: jogVelocitySlider
                Layout.fillWidth: true
                axis: axisRadioGroup.axis
                proportional: false
            }
        }

        RowLayout {
//            anchors.fill: parent
            anchors.margins: 10
            Layout.fillHeight: true
//            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                text: "This is for showing the Trinamic SPI registers\n" +
                    "The Chart represents the output of SG threshold"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: false
            Label {
                    Layout.fillWidth: true
                    text: "This is for setting up Trinamic SPI parameters\n" +
                        "The Chart represents the output of SG threshold"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                HalButton {
                    Layout.alignment: Layout.Center
                    name: "button0"
                    text: "Button 0"
                    checkable: true
                }

                HalButton {
                    Layout.alignment: Layout.Center
                    name: "button1"
                    text: qsTr("Button 1")
                }

                HalLed {
                    Layout.alignment: Layout.Center
                    name: "led"
                }

                Label {
                    Layout.fillWidth: true
                    text: "The buttons are connected using the 'and2' component in HAL.\n" +
                        "The LED represents the output of the 'and2' component."
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }

            Label {
                Layout.fillWidth: true
                text: "This is for setting up Trinamic SPI parameters\n" +
                    "The Chart represents the output of SG threshold"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            Layout.fillWidth: true
            id: control
            visible: true
            Label {
                id: sgtValsetLabel
                font.bold: true
                text: "sgt set:"
            }

            HalSpinBox {
                Layout.fillWidth: true
                id: sgtSetSpin
                enabled: errorLed.value === false
                name: "sgt.set"
                halPin.direction: HalPin.IO
                minimumValue: root.spinMinimumValue
                maximumValue: root.spinMaximumValue
                decimals: 0
                suffix: ""

                onEditingFinished: {            // remove the focus from this control
                    parent.forceActiveFocus()
                    parent.focus = true
                }
            }

            Switch {
                id: onOffSwitch
                enabled: errorLed.value === false
                onCheckedChanged: {
                    if (checked) {
                        if (sgtSetSpin.value == 0) {
                            sgtSetSpin.value = root.lastSgtValue
                        }
                    }
                        else {
                            root.lastSgtValue = sgtSetSpin.value
                            sgtSetSpin.value = 0
                        }
                }

                Binding {
                    target: onOffSwitch
                    property: "checked"
                    value: sgtSetSpin.value > 0.0
                }
            }
        }

        HalGauge {
            id: sgGauge
            Layout.fillWidth: true
            name: "sg.meas"
            suffix: ""
            decimals: 0
            valueVisible: !errorLed.value
            minimumValueVisible: false
            maximumValueVisible: false
            minimumValue: root.gaugeMinimumValue
            maximumValue: root.gaugeMaximumValue
            z0BorderValue: root.gaugeZ0BorderValue
            z1BorderValue: root.gaugeZ1BorderValue
            z0Color: valueVisible ? "green" : "white"
            z1Color: valueVisible ? "yellow" : "white"
            z2Color: valueVisible ? "red" : "white"

            Label {
                anchors.centerIn: parent
                text: qsTr("N/A")
                visible: !sgGauge.valueVisible
            }

            MouseArea {
                anchors.fill: parent
//                 onDoubleClicked: sgChart.visible = !sgChart.visible
//                 onClicked: control.visible = !control.visible
                onDoubleClicked: control.visible = !control.visible
                onClicked: sgChart.visible = !sgChart.visible
                cursorShape: "PointingHandCursor"
            }
        }

        LogChart {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            id: sgChart
            Layout.fillHeight: true
            visible: false
            value: sgGauge.value
            minimumValue: sgGauge.minimumValue
            maximumValue: sgGauge.maximumValue
            leftTextVisible: false
            rightTextVisible: false
            autoSampling: (sgGauge.halPin.synced) && visible
            autoUpdate: autoSampling
            updateInterval: 500
            timeSpan: 120000
//            changeGraphScale: 1
//            scrollZoomFactor: 1
//            sampleInterval: 1
//            minimumValue: -100
            Layout.maximumHeight: 256
            Layout.maximumWidth: 256
            gridColor: qsTr("#eeeeee")
            backgroundColor: qsTr("#ffffff")
//            maximumValue: 100
//            targetValue: 0
        }

        Item {
            Layout.fillHeight: true
        }
    }

//     DisplayPanel {
//         id: displayPanel
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.bottom: applicationProgressBar.top
//         width: parent.width * 0.20
//         anchors.margins: Screen.pixelDensity
//     }

    ApplicationNotifications {
        id: applicationNotifications
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: Screen.pixelDensity
        messageWidth: parent.width * 0.25
    }
}










