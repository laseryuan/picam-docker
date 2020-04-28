group "default" {
    targets = [
      "rtmp", 
      "rtmp-push", 
    ]
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
