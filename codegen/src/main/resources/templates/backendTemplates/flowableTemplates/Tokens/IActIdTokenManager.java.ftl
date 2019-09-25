package [=PackageName].domain.Flowable.Tokens;

public interface IActIdTokenManager {
// CRUD Operations
ActIdTokenEntity generateNewToken(String tokenId);

void insertToken(ActIdTokenEntity token);

void updateToken(ActIdTokenEntity token);

boolean isNewToken(ActIdTokenEntity token);

}
