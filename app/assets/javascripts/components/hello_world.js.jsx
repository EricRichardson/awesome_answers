var HelloWorld = function (props) {
  var styles = {
    color: "Salmon",
    backgroundColor: 'MidnightBlue',
    fontSize: props.fontSize + 'px',
    display: 'inline-block',
    borderRadius: '5px',
    padding: '0 5px'
  };

  return <p style={styles}>Hello World and Hello {props.name}</p>;
};
