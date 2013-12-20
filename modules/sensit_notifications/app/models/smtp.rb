# == Schema Information
#
# Table name: smtps
#
#  id            :integer(4)      not null, primary key
#  server        :string(255)
#  port          :integer(4)
#  username      :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  email_address :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Smtp
  include ActiveAttr::Model
  # include ActiveAttr::Attributes
  # # include ActiveAttr::TypecastedAttributes
  # include ActiveAttr::MassAssignment
  # include ActiveAttr::MassAssignmentSecurity
  
  FILE_PATH = "db/smtp.yml"
  SECRET = "fcfb41b7aeb3cf50c2d0d7fa67cc63eaa68cc53dbbbd8f46f34b1d078ebba56b"
  
  # attr_accessible :domain, :address, :port, :username, :password, :password_confirmation, :crypted_password
  
  attribute :domain#, :type => String
  attribute :address#, :type => String
  attribute :port#, :type => Integer
  attribute :username#, :type => String
  attribute :crypted_password#, :type => String
  
  
  validates_presence_of :address, :port, :domain
  validates :port, :numericality => {
    :only_integer => true,
    :greater_than => 0,
    :less_than => 10000
  }
  
  validates_confirmation_of :password, :if => Proc.new{ |smtp| smtp.username.present?}
  
  def initialize(attrs = {})
      if attrs.present?
        super(attrs)
      elsif Smtp.exists?
        file = File.new(FILE_PATH, "r")
        yaml = YAML::parse_file(file)
        if yaml
          hash = yaml.to_ruby
          super(hash)
        end
        file.close
      else
        super
      end
    end
  
  # after_initialize :encrypt_password, :if => Proc.new {|smtp| smtp.password.present? && smtp.password_confirmation.present?}
  
  # validates :server, 
  validates_email :domain
  
  validates :password, :password_confirmation, :presence => true, :if => Proc.new{ |smtp| smtp.username.present?}
  
  # smtp validation
  # check connection
  
  
  def save
    if self.valid?
      # encrypt_password
      file = File.new(FILE_PATH, "w+")
      YAML::dump(self.attributes, file)
      file.close
    end
  end
  
  def self.destroy
    flag = exists? ? File.delete(FILE_PATH) : 0
    flag > 0 ? true : false
  end
  
  def self.exists?
    File.file?(FILE_PATH)
  end

  def password=(value)
    self.crypted_password = value.blank? ? "": Encryptor.encrypt(value, :key => SECRET).dump
  end
  
  def password
    Encryptor.decrypt(eval(self.crypted_password), :key => SECRET) unless self.crypted_password.blank?
  end
  # send test email
  
  def self.domain
    smtp.domain
  end
  
  def self.address
    smtp.address
  end
  
  def self.port
    smtp.port.to_i
  end

  def self.username
    smtp.username
  end
  
  def self.password
    smtp.password
  end
  
  private
  
  def self.smtp
      @smtp ||= Smtp.new
  end

end
