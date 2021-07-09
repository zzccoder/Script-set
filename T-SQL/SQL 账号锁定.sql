
ALTER LOGIN sa ENABLE ;

GO

ALTER LOGIN sa WITH PASSWORD = 'password' unlock, check_policy = off,

check_expiration = off ;

GO