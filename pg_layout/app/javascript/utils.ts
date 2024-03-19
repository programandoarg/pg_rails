export function round (value) {
  return Math.round(value * 100) / 100
}

export function printCurrency (value, simboloMoneda = '$') {
  if (typeof value === 'string') {
    value = parseFloat(value)
  }
  const decimals = (value % 1 > 0) ? 2 : 0
  return simboloMoneda + ' ' + numberWithDots(value.toFixed(decimals).replace('.', ','))
}

export function showPercentage (value) {
  return '% ' + value
}

export function numberWithDots (x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

export function onAnimationEndShow (e) {
  e.target.style.visibility = 'visible'
  e.target.classList.remove('fade-in')
}

export function onAnimationEndHide (e) {
  e.target.style.visibility = 'hidden'
  e.target.classList.remove('fade-out')
}

export function fadeOut (e) {
  if (window.getComputedStyle(e).visibility !== 'hidden') {
    e.classList.add('fade-out')
    e.addEventListener('animationend', onAnimationEndHide, { once: true })
  }
}

export function fadeIn (e) {
  if (window.getComputedStyle(e).visibility !== 'visible') {
    e.classList.add('fade-in')
    e.addEventListener('animationend', onAnimationEndShow, { once: true })
  }
}
