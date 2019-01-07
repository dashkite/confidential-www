import Path from "path"

source = Path.join process.cwd(), "src"
intermediate = Path.join process.cwd(), "intermediate"
target = Path.join process.cwd(), "build"

imagePattern = "jpg,png,svg,ico,gif"

export {source, intermediate, target, imagePattern}
