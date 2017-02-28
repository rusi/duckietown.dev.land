import React, {prefix} from 'react'
import { prefixLink } from 'gatsby-helpers'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import FontAwesome from 'react-fontawesome'
import { LinkContainer, IndexLinkContainer } from 'react-router-bootstrap'
import Headroom from 'react-headroom'

class SiteNav extends React.Component {
  render() {
    return (
      <Headroom>
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>
            <a href={prefixLink('/')}>Gatsby Template</a>
          </Navbar.Brand>
        </Navbar.Header>
        <Nav className="navbar-right">
          <IndexLinkContainer to={prefixLink('/')}>
            <NavItem eventKey={1}><FontAwesome name="home" className={'navBarIcon'} /> Home</NavItem>
          </IndexLinkContainer>
          <LinkContainer to={prefixLink('/sections/')}>
            <NavItem eventKey={2}><FontAwesome name="bars" className={'navBarIcon'} /> Sections</NavItem>
          </LinkContainer>
          <LinkContainer to={prefixLink('/about/')}>
            <NavItem eventKey={3}><FontAwesome name="question" className={'navBarIcon'} /> About</NavItem>
          </LinkContainer>
        </Nav>
      </Navbar>
      </Headroom>
    )
  }
}

export default SiteNav