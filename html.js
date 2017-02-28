import React, { PropTypes } from 'react'
import Helmet from "react-helmet"
import { prefixLink } from 'gatsby-helpers'

import { TypographyStyle, GoogleFont } from 'react-typography'
import typography from './utils/typography'

const BUILD_TIME = new Date().getTime()

function HTML (props) {
  const head = Helmet.rewind()

  let css
  if (process.env.NODE_ENV === 'production') {
    css = <style dangerouslySetInnerHTML={{ __html: require('!raw!./public/styles.css') }} />
  }

  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0 maximum-scale=5.0"
        />
        <TypographyStyle typography={typography} />
        <GoogleFont typography={typography} />
        {css}
        <link rel="stylesheet" href="https://bootswatch.com/flatly/bootstrap.min.css"/>
        {/*<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css"/>*/}
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
        {head.title.toComponent()}
        {head.meta.toComponent()}
      </head>
      <body>
        <div id="react-mount" dangerouslySetInnerHTML={{ __html: props.body }} />
        <script src={prefixLink('/bundle.js?t=${BUILD_TIME}')} />
      </body>
    </html>
  )
}

HTML.propTypes = { body: PropTypes.node }

module.exports = HTML
