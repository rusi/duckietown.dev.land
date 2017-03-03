import React, {prefix} from 'react'
import { prefixLink } from 'gatsby-helpers'
import { Navbar, Nav, NavItem, NavDropdown, MenuItem } from 'react-bootstrap'
import FontAwesome from 'react-fontawesome'
import { LinkContainer, IndexLinkContainer } from 'react-router-bootstrap'
import Headroom from 'react-headroom'
import { withRouter } from 'react-router'

class SiteNav extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let buildTitle = <span><FontAwesome name="wrench" className={'navBarIcon'} /> Build</span>
    let learnTitle = <span><FontAwesome name="book" className={'navBarIcon'} /> Learn</span>
    let exploreTitle = <span><FontAwesome name="globe" className={'navBarIcon'} /> Explore</span>

    const { router } = this.props;
    let activeBuild=""
    if (router.isActive('/build/duckiebot', false) ||
      router.isActive('/build/duckietown', false)) {
      activeBuild = "active"
    }
    let activeLearn=""
    if (router.isActive('/learn/rules', false) ||
      router.isActive('/learn/getting_started', false) ||
      router.isActive('/learn/blockly', false)) {
      activeLearn = "active"
    }
    let activeExplore=""
    if (router.isActive('/explore/advanced', false)) {
      activeExplore = "active"
    }

    let navStyle = ""
    if (router.isActive('/', true)) {
      navStyle = "splash"
    }

    return (
      // <Headroom>
      <Navbar
        collapseOnSelect
        componentClass="header"
        className={navStyle}
        role="banner"
      >
        <Navbar.Header>
          <Navbar.Brand>
            <a href={prefixLink('/')}>Duckietown</a>
          </Navbar.Brand>
          <Navbar.Toggle/>
        </Navbar.Header>
        <Navbar.Collapse>
          <Nav className="navbar-right">
            <IndexLinkContainer to={prefixLink('/')}>
              <NavItem eventKey={1}><FontAwesome name="home" className={'navBarIcon'} /> Home</NavItem>
            </IndexLinkContainer>

            <NavDropdown eventKey={2} title={buildTitle} id="nav-dropdown" className={activeBuild}>
              <LinkContainer to={prefixLink('/build/duckietown/')}>
                <MenuItem eventKey={2.1}>DuckieTown</MenuItem>
              </LinkContainer>
              <LinkContainer to={prefixLink('/build/duckiebot/')}>
                <MenuItem eventKey={2.2}>DuckieBot</MenuItem>
              </LinkContainer>
              <MenuItem divider />
              <MenuItem eventKey={2.3}>Software</MenuItem>
            </NavDropdown>

            <NavDropdown eventKey={3} title={learnTitle} id="nav-dropdown" className={activeLearn}>
              <LinkContainer to={prefixLink('/learn/rules/')}>
                <MenuItem eventKey={3.1}>Rules & Regulations</MenuItem>
              </LinkContainer>
              <MenuItem divider />
              <LinkContainer to={prefixLink('/learn/getting_started/')}>
                <MenuItem eventKey={3.2}>Getting Started</MenuItem>
              </LinkContainer>
              <LinkContainer to={prefixLink('/learn/blockly/')}>
                <MenuItem eventKey={3.3}>Blockly</MenuItem>
              </LinkContainer>
            </NavDropdown>

            <NavDropdown eventKey={4} title={exploreTitle} id="nav-dropdown" className={activeExplore}>
              <LinkContainer to={prefixLink('/explore/advanced/')}>
                <MenuItem eventKey={4.1}>Advanced Topics</MenuItem>
              </LinkContainer>
            </NavDropdown>

            <LinkContainer to={prefixLink('/about/')}>
              <NavItem eventKey={5}><FontAwesome name="question" className={'navBarIcon'} /> About</NavItem>
            </LinkContainer>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
      // </Headroom>
    )
  }
}

export default withRouter(SiteNav)