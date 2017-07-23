import QtQuick 2.4
import QtQuick.Window 2.2


/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0


// This example illustrates expanding a list item to show a more detailed view.

Rectangle {
    id: page
    width: 400; height: 300
    color: "black"

    // Delegate for the cpu.  This delegate has two modes:
    // 1. List mode (default), which just shows the processor id, model name and processor frequency.
    // 2. Details mode, which also shows the remaining processor details.
    Component {
        id: cpuDelegate
//! [0]
        Item {
            id: cpu

            // Create a property to contain the visibility of the details.
            // We can bind multiple element's opacity to this one property,
            // rather than having a "PropertyChanges" line for each element we
            // want to fade.
            property real detailsOpacity : 0
//! [0]
            width: listView.width
            height: 70

            // A simple rounded rectangle for the background
            Rectangle {
                id: background
                x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*2
                color: "ivory"
                border.color: "blue"
                radius: 5
            }

            // This mouse region covers the entire delegate.
            // When clicked it changes mode to 'Details'.  If we are already
            // in Details mode, then no change will happen.
//! [1]
            MouseArea {
                anchors.fill: parent
                onClicked: cpu.state = 'Details';
            }

            // Lay out the page: processor id and model name at the top, and remaining details at the
            // bottom.  Note that elements that should not be visible in the list
            // mode have their opacity set to cpu.detailsOpacity.

            Row {
                id: topLayout
                x: 10; y: 10; height: 20; width: parent.width
                spacing: 10

                Column {
                    width: background.width; height: 50
                    spacing: 5

                    Text {
                        text: processor + ". " + model_name
                        font.bold: true; font.pointSize: 16


                    }

                    Text {
                        text: cpu_MHz + " MHz"
                        font.bold: true; font.pointSize: 13

//                        opacity: cpu.detailsOpacity
                    }


                }
            }

//! [2]
            Item {
                id: details
                x: 10; width: parent.width - 20

                anchors { top: topLayout.bottom; topMargin: 55; bottom: parent.bottom; bottomMargin: 10 }
                opacity: cpu.detailsOpacity
//! [2]


                Rectangle {
                    id: backgroundDetails
                    width: parent.width ; height: detailsText.height + cpufullDetails.height+ 20//parent.height - y*2
                    color: "#eaf5f8"
                    border.color: "blue"
                    radius: 2
                }
                Text {
                    id: cpufullDetails
                    anchors.top: parent.top
                    text: "CPU Details"
                    color: "blue"
                    font.pointSize: 12; font.bold: true


                }

                    Flickable {
                        id: flick
                        x:5; width: parent.width
                        anchors { top: cpufullDetails.bottom; bottom: parent.bottom; topMargin: 20 }
                        contentHeight: parent.height
                        clip: true

                        SmallText { id: detailsText; text: CpuModel.prettyFormat(index); wrapMode: Text.WordWrap; width: details.width }
                    }

//! [3]
            }



            // A button to close the detailed view, i.e. set the state back to default ('').
            TextButton {
                y: 10
                anchors { right: background.right; rightMargin: 10 }
                opacity: cpu.detailsOpacity
                text: "Close"

                onClicked: cpu.state = '';
            }

            states: State {
                name: "Details"

                PropertyChanges { target: background; color: "white" }
//                PropertyChanges { target: recipeImage; width: 130; height: 130 } // Make picture bigger
                PropertyChanges { target: cpu; detailsOpacity: 1; x: 0 } // Make details visible
                PropertyChanges { target: cpu; height: listView.height } // Fill the entire list area with the detailed view

                // Move the list so that this item is at the top.
                PropertyChanges { target: cpu.ListView.view; explicit: true; contentY: cpu.y }

                // Disallow flicking while we're in detailed view
                PropertyChanges { target: cpu.ListView.view; interactive: false }
            }

            transitions: Transition {
                // Make the state changes smooth
                ParallelAnimation {
                    ColorAnimation { property: "color"; duration: 500 }
                    NumberAnimation { duration: 300; properties: "detailsOpacity,x,contentY,height,width" }
                }
            }
        }
//! [3]


    }


    // The actual list
    ListView {
        id: listView
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        currentIndex: 0
        model: CpuModel
        delegate: cpuDelegate
    }


    // Refresh button

    TextButton {
        id: refreshButon

            anchors.bottom: parent.bottom
//            anchors.left: parent.left
            width: listView.width
            anchors.margins: 5
            height: 30

            color: "#98cfe0"
            border.color: "black"
//            opacity: parent.opacity
            Accessible.role: Accessible.Button

        Text {
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 20
               style: Text.Raised
            // TODO: translate
            text: "Refresh"
        }

        MouseArea {
                anchors.fill: parent
            onClicked: {
                CpuModel.populateModel();

                // little hack to trigger update the full info text
    //            var index = listView.currentIndex;
    //            listView.currentIndex = -1;
    //            listView.currentIndex = index;


            }
        }
    }

}

