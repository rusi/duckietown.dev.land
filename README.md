# Minimalistic Gatsby Starter Template
---

# Installation
---
Install this starter (assuming Gatsby is installed) by running from your CLI: 
```
gatsby new your-site-dir gh:rusi/gatsby-starter-site
```

# Running in development
```
gatsby develop
```

# Deploy

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/rusi/gatsby-starter-site)

# Customizations

## Default Templates

Gatsby is currently using the default template for HTML. You can override
this functionality by creating a React component at "/html.js"

You can see what this default template does by visiting:
https://github.com/gatsbyjs/gatsby/blob/master/lib/isomorphic/html.js

Gatsby is currently using the default _template. You can override it by
creating a React component at "/pages/_template.js".

You can see what this default template does by visiting:
https://github.com/gatsbyjs/gatsby/blob/master/lib/isomorphic/pages/_template.js

## Wrappers

By default Gatsby has two built-in wrappers for html and markdown (see https://github.com/gatsbyjs/gatsby/tree/master/lib/isomorphic/wrappers)

This project overwrites the default wrappers and adds a few more wrappers copied form the "clean" starter template.

### wrappers/md.js styles

The default Gatsby markdown loader parses the markdown into HTML and uses Highlight.js to syntax highlight code blocks.

The md.js wrapper includes a [highlightjs](https://highlightjs.org) style which is copied under the css/ directory. 

See a [demo](https://highlightjs.org/static/demo/) of available styles that can be downloaded from https://github.com/isagalaev/highlight.js/tree/master/src/styles

## Typography

The template includes the use of [TypographyJS](http://kyleamathews.github.io/typography.js/)

## Bootstrap & NavBar

The template uses Bootstrap template from [Bootswatch](https://bootswatch.com) and adds a navigation bar.

You can change the theme by including a different Bootstrap stylesheet in html.js.
