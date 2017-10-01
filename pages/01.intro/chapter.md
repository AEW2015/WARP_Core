---
title: Introduction
taxonomy:
    category:
        - docs
child_type: docs
---

### Chapter 0

# Introduction

A VHDL and Verilog Processor designed for academic purposes and future potential as a soft-core processor build for space

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>constructor-selector</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <!-- 1. Define some markup -->
    <button class="btn" data-clipboard-text="1">Copy</button>
    <button class="btn" data-clipboard-text="2">Copy</button>
    <button class="btn" data-clipboard-text="3">Copy</button>

    <!-- 2. Include library -->
    <script src="https://cdn.rawgit.com/zenorocha/clipboard.js/v1.7.1/dist/clipboard.min.js"></script>

    <!-- 3. Instantiate clipboard by passing a string selector -->
    <script>
    var clipboard = new Clipboard('.btn');
    clipboard.on('success', function(e) {
        console.log(e);
    });
    clipboard.on('error', function(e) {
        console.log(e);
    });
    </script>
</body>
</html>