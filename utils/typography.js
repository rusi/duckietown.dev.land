
import Typography from 'typography'
import altonTheme from 'typography-theme-alton'
import CodePlugin from 'typography-plugin-code'

altonTheme.plugins = [
  new CodePlugin(),
]

const typography = new Typography(altonTheme)

export default typography
