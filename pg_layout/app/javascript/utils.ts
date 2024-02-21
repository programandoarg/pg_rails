export function round (value) {
  return Math.round(value * 100) / 100
}

export function printCurrency (value, moneda) {
  return monedaSimbolo(moneda) + numberWithDots(round(value).toFixed(2).replace('.', ','))
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
