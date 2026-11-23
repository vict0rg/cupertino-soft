import fs from "node:fs";
import assert from "node:assert/strict";

const css = fs.readFileSync("theme.css","utf8");
const manifest = JSON.parse(fs.readFileSync("manifest.json","utf8"));
assert.equal(manifest.name,"Cupertino Soft");
assert.equal(manifest.version,"0.4.1");
assert.ok(css.length > 7000 && css.length < 45000, "Theme must remain lean and layout-safe");
for (const required of [
  "#FAFAFA","#EBEBED","#F2F2F4","#333338","#FF3B30","#FFE9E8",
  "titlebar-button.mod-close:hover","tbody tr:nth-child(even)",
  "markdown-source-view.mod-cm6","CUPERTINO SOFT THEME v0.4.1"
]) assert.ok(css.includes(required), required);

// Prevent the upstream visibility regressions from being reintroduced.
for (const prohibited of [
  /\.workspace-tab-header-container:not\(:hover\)/,
  /\.nav-buttons-container svg\s*\{[^}]*width:\s*0px/s,
  /\.workspace-tab-header[^\{]*\{[^}]*opacity:\s*0/s,
  /\.titlebar-button[^\{]*\{[^}]*mask-image:/s,
  /\.titlebar-button[^\{]*\{[^}]*visibility:\s*hidden/s,
  /\.workspace-tabs[^\{]*\{[^}]*display:\s*none/s,
  /\.mod-root::before/,
  /\.workspace-tab-header-container-inner[^\{]*\{[^}]*padding-left:\s*calc/s
]) assert.doesNotMatch(css,prohibited,"No structural hiding or upstream layout overrides allowed");
assert.match(css, /\.metadata-container/);
assert.match(css, /--soft-selection:\s*#FFE9E8/);
assert.match(css, /--text-normal:\s*#333338/);
assert.match(css, /\.metadata-container \.metadata-property-key/);
const spellingRule = css.match(/\.theme-light ::spelling-error,\s*\.theme-dark ::spelling-error\s*\{([^}]*)\}/);
assert.ok(spellingRule,"Native spelling-error rule must be present in both modes");
assert.match(spellingRule[1],/text-decoration:\s*underline\s+wavy\s+#FF9500\s*!important/,"Spellcheck must explicitly draw its wavy underline, not just recolor it");
assert.match(spellingRule[1],/text-decoration-color:\s*#FF9500/);
assert.doesNotMatch(spellingRule[1],/(?:^|;)\s*color\s*:/,"Misspelled words must retain normal text color");
assert.match(css, /border-collapse:\s*collapse/);
assert.match(css, /padding:\s*6px 9px/);
assert.match(css, /--table-row-alt-background/);
assert.match(fs.readFileSync("LICENSE","utf8"),/MIT License|Permission is hereby granted/);
let depth=0,comment=false,quote=null;
for(let i=0;i<css.length;i++) {
  const c=css[i], next=css[i+1];
  if(comment){if(c==="*"&&next==="/"){comment=false;i++;}continue;}
  if(quote){if(c==="\\"){i++;continue;}if(c===quote)quote=null;continue;}
  if(c==="/"&&next==="*"){comment=true;i++;continue;}
  if(c==='"'||c==="'"){quote=c;continue;}
  if(c==="{")depth++;
  if(c==="}"){depth--;assert.ok(depth>=0,"Unexpected } in CSS");}
}
assert.doesNotMatch(css, /@import\s+(?:url\()?\s*["\x27]?https?:/i, "Theme must not load network CSS");
assert.doesNotMatch(css, /url\(\s*["\x27]?https?:/i, "Theme must not load network assets");
assert.equal(depth,0);
assert.ok(!comment && !quote);
console.log("Cupertino Soft v0.4.1: palette and explicit spellcheck decoration validated; app chrome remains native.");
