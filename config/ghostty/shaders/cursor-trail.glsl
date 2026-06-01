// Optional Ghostty shader playground.
// Keep disabled in the main config until tested; a bad shader can make Ghostty unreadable.

float roundedBox(vec2 p, vec2 halfSize, float radius) {
    vec2 q = abs(p) - halfSize + radius;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    if (iCursorVisible.x <= 0.0 || iFocus <= 0) {
        fragColor = base;
        return;
    }

    vec2 currentCenter = iCurrentCursor.xy + iCurrentCursor.zw * 0.5;
    vec2 previousCenter = iPreviousCursor.xy + iPreviousCursor.zw * 0.5;
    vec2 halfSize = max(iCurrentCursor.zw * 0.65, vec2(6.0));

    float age = clamp(iTime - iTimeCursorChange, 0.0, 0.45);
    float fade = 1.0 - smoothstep(0.0, 0.45, age);

    float currentGlow = 1.0 - smoothstep(0.0, 18.0, roundedBox(fragCoord - currentCenter, halfSize, 5.0));
    float previousGlow = 1.0 - smoothstep(0.0, 28.0, roundedBox(fragCoord - previousCenter, halfSize, 7.0));

    vec3 glow = iCursorColor.rgb * (currentGlow * 0.10 + previousGlow * fade * 0.28);
    fragColor = vec4(base.rgb + glow, base.a);
}
