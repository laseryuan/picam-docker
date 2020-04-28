group "default" {
    targets = [
      "rtmp", 
    ]
}

target "rtmp" {
    dockerfile = "rtmp/Dockerfile"
    platforms = [
        "linux/arm/v6"
    ]
    tags = ["rtmp"]
    output = ["type=docker"]
}
