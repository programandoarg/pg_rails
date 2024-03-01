export function round (value) {
  return Math.round(value * 100) / 100
}

export function printCurrency (value, simboloMoneda = '$') {
  let decimals = (value % 1 > 0) ? 2 : 0
  return simboloMoneda + ' ' + numberWithDots(value.toFixed(decimals).replace('.', ','))
}

export function showPercentage (value) {
  return '% ' + value
}

export function numberWithDots (x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}
