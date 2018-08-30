const progressColor = (value) => {
  value = parseInt(value)

  if (range(0,24).includes(value)) return 'bg-red'
  if (range(25,49).includes(value)) return 'bg-orange'
  if (range(50,74).includes(value)) return 'bg-yellow'
  if (range(75,100).includes(value)) return 'bg-green'
  return 'bg-red'
}
