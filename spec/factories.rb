Factory.define :user do |u|
  u.email     "john@demo.com"
  u.password  "password"
end

Factory.define :tweet do |t|
  t.content   "what what in the b*tt"
end

Factory.define :relationship do |r|
end

# article
# has many comments
#Factory.define :article_with_comment, :parent => :article do |article|
#  article.after_create { |a| Factory(:comment, :article => a) }
#end