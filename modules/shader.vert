module.exports = "precision mediump float;\n" +
"\n" +
"attribute vec3 aPosition;\n" +
"attribute vec3 aNormal;\n" +
"attribute vec2 aUv;\n" +
"\n" +
"varying vec2 vUv;\n" +
"\n" +
"uniform mat4 uProjection;\n" +
"uniform mat4 uModel;\n" +
"uniform mat4 uView;\n" +
"\n" +
"void main() {\n" +
  "vUv = aUv;\n" +
  "gl_Position = uProjection * uView * uModel * vec4(aPosition, 1.0);\n" +
"}"