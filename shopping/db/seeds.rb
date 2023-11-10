if Category.count == 0
  Category.create([
    {name: '書籍'},
    {name: '家電'},
    {name: 'ファッション'},
    {name: 'DVD/CD'},
    {name: '食品'},
    {name: 'その他'}
  ])
end


Review.create([
    {rating: '1'},
    {rating: '2'},
    {rating: '3'},
    {rating: '4'},
    {rating: '5'}
  ])


Mode.create([
  {name: '管理者'},
  {name: '販売者'},
  {name: '購入者'}
])