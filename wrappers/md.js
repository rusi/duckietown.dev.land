import React from 'react'
import 'css/highlightjs-xcode.css'
import Helmet from "react-helmet"
import { config } from 'config'

module.exports = React.createClass({
  propTypes () {
    return {
      router: React.PropTypes.object,
    }
  },
  render () {
    const post = this.props.route.page.data
    let titleElement = "";
    if (post.title) {
      titleElement = <h1>{post.title}</h1>
    }
    return (
      <div className="markdown">
        <Helmet
          title={`${config.siteTitle} | ${post.title}`}
        />
        {titleElement}
        <div dangerouslySetInnerHTML={{ __html: post.body }} />
      </div>
    )
  },
})
