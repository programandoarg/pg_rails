export function round (value) {
  return Math.round(value * 100) / 100
}

export function printCurrency (value, moneda) {
  let decimals = (value % 1 > 0) ? 2 : 0
  return monedaSimbolo(moneda) + numberWithDots(value.toFixed(decimals).replace('.', ','))
}

export function showPercentage (value) {
  return '% ' + value
}

export function monedaSimbolo (moneda) {
  switch (moneda) {
    case 'pesos':
      return '$ '
    case 'dolares':
      return 'U$S '
    case 'euros':
      return '€ '
    case 'reales':
      return 'R$ '
    case 'pesos_chilenos':
      return 'CLP '
    case 'pesos_mexicanos':
      return 'MXN '
    default:
      return '$ '
  }
}

export function numberWithDots (x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}
