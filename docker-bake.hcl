group "default" {
    targets = [
//      "rtmp",
      "rtmp-push",
//      "picam",
//      "picam-push",
    ]
}

target "picam" {
    dockerfile = "picam/Dockerfile"
    platforms = [
        "linux/arm/v6"
    ]
    tags = ["watchdog:picam"]
    output = ["type=docker"]
}

target "picam-push" {
    dockerfile = "picam/Dockerfile"
    platforms = [
        "linux/arm/v6"
    ]
    tags = ["lasery/watchdog:picam"]
    output = ["type=registry"]
}

target "rtmp" {
    dockerfile = "rtmp/Dockerfile"
    platforms = [
        "linux/arm/v6"
    ]
    tags = ["watchdog:rtmp"]
    output = ["type=docker"]
}

target "rtmp-push" {
    dockerfile = "rtmp/Dockerfile"
    platforms = [
        "linux/arm/v6"
    ]
    tags = ["lasery/watchdog:rtmp"]
    output = ["type=registry"]
}
