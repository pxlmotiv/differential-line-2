#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 u_resolution;
uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_color3;
uniform vec3 u_color4;
uniform float u_time;

varying vec4 vertColor;

// Some useful functions
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }
float random (vec2 st) { return fract(sin(dot(st.xy,vec2(12.9898, 78.233)))*43758.5453123);}

float noise (in vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);

  // Four corners in 2D of a tile
  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = f * f * (3.0 - 2.0 * f);
  
  return mix(a, b, u.x) + 
         (c - a)* u.y * (1.0 - u.x) + 
         (d - b) * u.x * u.y;
}

float snoise(vec2 v) {
    // Precompute values for skewed triangular grid
    const vec4 C = vec4(0.211324865405187,
                        // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,
                        // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,
                        // -1.0 + 2.0 * C.x
                        0.024390243902439);
                        // 1.0 / 41.0

    // First corner (x0)
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);

    // Other two corners (x1, x2)
    vec2 i1 = vec2(0.0);
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec2 x1 = x0.xy + C.xx - i1;
    vec2 x2 = x0.xy + C.zz;

    // Do some permutations to avoid
    // truncation effects in permutation
    i = mod289(i);
    vec3 p = permute(
            permute( i.y + vec3(0.0, i1.y, 1.0))
                + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(
                        dot(x0,x0),
                        dot(x1,x1),
                        dot(x2,x2)
                        ), 0.0);

    m = m*m ;
    m = m*m ;

    // Gradients:
    //  41 pts uniformly over a line, mapped onto a diamond
    //  The ring size 17*17 = 289 is close to a multiple
    //      of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt(a0*a0 + h*h);
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);

    // Compute final noise value at P
    vec3 g = vec3(0.0);
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
    return 130.0 * dot(m, g);
}

const mat2 m2 = mat2(0.8, -0.6, 0.6, 0.8);
float simpleFbm ( in vec2 p ){
  float f = 0.0;

  f += 0.5000 * noise( p ); p = m2*p*2.02;
  f += 0.2500 * noise( p ); p = m2*p*2.03;
  f += 0.1250 * noise( p ); p = m2*p*2.01;
  f += 0.0625 * noise( p );

  return f / 0.9375;
}

#define OCTAVES 6
float fbm (in vec2 st) {
  float value = 0.0;
  float amplitude = 0.5;
  
  for (int i = 0; i < OCTAVES; i++) {
    value += amplitude * noise(st);
    st *= 2.;
    amplitude *= .5;
  }

  return value;
}

float turbulence (in vec2 st) {
  float value = 0.0;
  float amplitude = 0.5;
  
  for (int i = 0; i < OCTAVES; i++) {
    value += amplitude * abs(snoise(st));
    st *= 2.;
    amplitude *= .5;
  }

  return value;
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  st.x *= u_resolution.x / u_resolution.y;

  vec3 color = vec3(0.0);

  vec2 q = vec2(0.);
  q.x = turbulence( st );
  q.y = turbulence( st + vec2(1.0));

  vec2 r = vec2(0.);
  r.x = turbulence( st + 1.0*q + vec2(1.7,9.2) + 0.015 * u_time);
  r.y = fbm( st + 1.0*q + vec2(8.3,2.8) + 0.063 * u_time);

  float f = fbm(st + r);

  color = mix(u_color1,
              u_color2,
              clamp((f*f)*4.0, 0.0, 1.0));

  color = mix(color,
              u_color3,
              clamp(length(q),0.0,1.0));

  color = mix(color,
              u_color4,
              clamp(length(r.x),0.0,1.0));

  gl_FragColor = vec4((f*f + .6*f*f + .5*f) * color, 1.);
}