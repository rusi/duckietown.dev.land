import React, { PropTypes } from 'react'
import { Container } from 'react-responsive-grid'
import { rhythm } from '../utils/typography'

import SiteNav from '../components/SiteNav'
import StickyFooter from '../components/StickyFooter'

import '../css/main.css'
import '../styles/styles'
// import '../css/bootstrap.css'
// import '../css/bootstrap-flatly.css'

function template (props) {
  return (
    <div>
      <SiteNav/>
      <Container
        style={{
          maxWidth: 700,
          padding: `${rhythm(1)} ${rhythm(3/4)}`,
          paddingTop: 0,
        }}
      >
        {props.children}
      </Container>
      <StickyFooter/>
    </div>
  )
}

template.propTypes = { children: PropTypes.node }

module.exports = template
