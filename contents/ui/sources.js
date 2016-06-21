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

var ImageSources = {
    SourceBing: bingIotd,
    SourceNasa: nasaApod,
    SourceUnsplash: unsplashApi
}

function bingIotd(callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
            var data = JSON.parse(xhr.responseText).images[0];
            var baseUrl = "https://www.bing.com";
            var imgSrc = baseUrl + data.url;
            callback(imgSrc, data.copyright, "../assets/bing.svg");
        }
    }
    xhr.open("GET", "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-NZ", true);
    xhr.send();
}

function nasaApod(callback) {
    var apiKey = "s2fu4xGkpRbhU2CPwNPDDZfWDtCF8eM22L8UUY6Q";
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
            var data = JSON.parse(xhr.responseText);
            var text = data.title;
            if (typeof(data.copyright) == "string") {
                text = text + "\n" + data.copyright;
            }
            callback(data.hdurl, text, "../assets/nasa.svg");
        }
    }
    xhr.open("GET", "https://api.nasa.gov/planetary/apod?hd=true&api_key=" + apiKey, true);
    xhr.send();
}

function unsplashApi(callback) {
    var appKey = "c0dfd678a1eb11d1ed039914f9aa9507a7e8759e133a27fa15ae8be9622a879f";
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
            var data = JSON.parse(xhr.responseText);
            var copy = "By " + data.user.name + ", " + data.created_at.slice(0, 4);
            callback(data.urls.raw, copy, "../assets/unsplash.svg");
        }
    }
    xhr.open("GET", "https://api.unsplash.com/photos/random?w=3840&h=2160", true);
    xhr.setRequestHeader("Accept-Version", "v1");
    xhr.setRequestHeader("Authorization", "Client-ID " + appKey);
    xhr.send();
}
