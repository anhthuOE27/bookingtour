4.times do |n|
  name  = "Category #{n}"
  Category.create!(name: name)
end


10.times do |n|
  categorys = Category.all
  name  = "Tour #{n}"
  startdate = Time.zone.now
  finishdate = 30.days.from_now
  amountpeople = 10
  category = categorys[0..3]
  foods = "sầu riêng"
  places = "Nghỉ ở nghìn chín, đi tham quan cù lao chàm"
  category.each { |item|
  Tour.create!(
    name: "#{name} #{item.name}",
    price: n*10,
    category: item,
    startdate: startdate,
    finishdate: finishdate,
    amountpeople: amountpeople
    food: foods,
    place: places
  )
  }
end

10.times do |n|
  name = Faker::Name.name
  email = "tranngoc-#{n}@gmail.com"
  password = "password"
  User.create!(
    fullname: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end

10.times do |n|
  users = User.all
  tours = Tour.all
  # name = Faker::Company.name
  content = "Lan thu #{n} viet review ne"
  user = users[1..10]
  tour = tours[1..3]
  user.each do |user|
    tour.each do |tour|
      Review.create(
        tour_id: tour.id,
        user_id: user.id,
        content: content
      )
    end
  end
end

10.times do |n|
  users = User.all
  tours = Tour.all
  reviews = Review.all
  content = "Comment thu #{n}"
  user = users[0..3]
  tour = tours[0..3]
  review = reviews[0..3]
  user.each do |user|
    tour.each do |tour|
      Comment.create(
        commentable_id: tour.id,
        commentable_type: tour.class,
        user_id: user.id,
        content: content
      )
    end
  end
  user.each do |user|
    review.each do |review|
      Comment.create(
        commentable_id: review.id,
        commentable_type: review.class,
        user_id: user.id,
        content: content
      )
    end
  end
end
