import React, {prefix} from 'react'
import FontAwesome from 'react-fontawesome'
// import { Grid, Row, Col } from 'react-bootstrap'

import '../css/StickyFooter'

class StickyFooter extends React.Component {
  render() {
    return (
      <footer>
        <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">
        <img alt="Creative Commons License" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" />
        </a>
        <br />
        <a href="http://duckietown.dev.land">Duckietown</a> is licensed under
        a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>
        <br />
        Based on a work at <a href="duckietown.mit.edu">duckietown.mit.edu</a>
        <br/><br/>
        Made with <FontAwesome name="heart-o" className="love"/> in Boston
        </footer>
    )
  }
}

export default StickyFooter