
import Typography from 'typography'
import altonTheme from 'typography-theme-alton'
import CodePlugin from 'typography-plugin-code'

altonTheme.plugins = [
  new CodePlugin(),
]
// altonTheme.baseFontSize = '22px'

const typography = new Typography(altonTheme)

// Hot reload typography in development.
if (process.env.NODE_ENV !== 'production') {
  typography.injectStyles();
}

export default typography
