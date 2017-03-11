import ReactGA from 'react-ga';
ReactGA.initialize('UA-333403-6');

exports.onRouteUpdate = (state, page, pages) => {
  if (process.env.NODE_ENV === 'production') {
    ReactGA.pageview(state.pathname);
  } else {
    console.log(state.pathname);
  }
};

