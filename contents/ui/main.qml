/*
 *  Copyright (C) 2016 Boudhayan Gupta <bgupta@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301, USA.
 */


import QtQuick 2.5
import org.kde.plasma.core 2.0 as PlasmaCore

import "./sources.js" as Sources

Rectangle {
    id: iotdRoot;
    objectName: "iotdRoot";

    anchors.fill: parent;
    color: wallpaper.configuration.Color;

    readonly property var allSources: [
        "SourceBing",
        "SourceNasa",
        "SourceUnsplash"
    ];
    property var enabledSources: [];

    function evalEnabledSources() {
        enabledSources.length = 0;
        for (var i in allSources) {
            if (wallpaper.configuration[allSources[i]] == true) {
                enabledSources.push(allSources[i]);
            }
        }
    }

    function changeImage() {
        evalEnabledSources();
        var index = Math.floor(Math.random() * enabledSources.length);
        var source = enabledSources[index];
        var imgfunc = Sources.ImageSources[source];

        imgfunc(setImageCallback);
        iotdSlideshowTimer.start();
    }

    function setImageCallback(imageUrl, imageTitleCopyright, sourceLogo) {
        iotdImage.source = imageUrl;
        iotdSourceLogo.source = sourceLogo;
        iotdCopyrightLabel.text = imageTitleCopyright;
    }

    Image {
        id: iotdImage;
        objectName: "iotdImage";
        anchors.fill: parent;

        fillMode: wallpaper.configuration.FillMode;
        cache: true;
        asynchronous: true;
        mipmap: true;

        Component.onCompleted: {
            changeImage();
            resetTimer();
        }

        Image {
            id: iotdSourceLogo;
            objectName: "iotdSourceLogo";

            width: (parent.width / 100) * 7.5;
            height: (parent.height / 100) * 7.5;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: Math.min((parent.height / 100) * 7.5, (parent.width / 100) * 7.5);
            anchors.rightMargin: 5;
            opacity: 0.25;

            fillMode: Image.PreserveAspectFit;
            cache: false;
            asynchronous: true;
            mipmap: true;
        }

        Text {
            id: iotdCopyrightLabel;
            objectName: "iotdCopyrightLabel";

            anchors.top: iotdSourceLogo.bottom;
            anchors.right: iotdSourceLogo.right;
            anchors.margins: 5;

            color: Qt.rgba(0.75, 0.75, 0.75, 0.95);
            font.weight: Font.DemiBold;
            font.pointSize: 9;
        }
    }

    Timer {
        id: iotdSlideshowTimer;
        objectName: "iotdSlideshowTimer";

        running: false;
        interval: wallpaper.configuration.ChangeInterval;
        repeat: false;

        onTriggered: {
            evalEnabledSources();
            changeImage();
        }
    }
}
