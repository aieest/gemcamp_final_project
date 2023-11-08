class AdminDomainConstraint
  def matches?(request)
    domains = ['admin.com']
    domains.include?(request.domain.downcase)
  end
end