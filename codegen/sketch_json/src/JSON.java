import java.util.Set;
import java.io.IOException;;

import sketch.compiler.ast.core.FENullVisitor;
import sketch.compiler.ast.core.Program;
import sketch.compiler.ast.core.FENode;
import sketch.util.annot.CodeGenerator;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.TypeAdapter;
import com.google.gson.TypeAdapterFactory;
import com.google.gson.stream.JsonWriter;
import com.google.gson.stream.JsonReader;
import com.google.gson.reflect.TypeToken;

@CodeGenerator
public class JSON extends FENullVisitor {
  @Override
  public Object visitProgram(Program prog) {
    GsonBuilder gsonBuilder = new GsonBuilder();
    FENodeTypeAdapterFactory adapterFactory = new FENodeTypeAdapterFactory();
    gsonBuilder.registerTypeAdapterFactory(adapterFactory);
    Gson gson = gsonBuilder.create();
    String jsonInString = gson.toJson(prog);
    System.out.println("------------");
    System.out.println(jsonInString);
    return null;
  }

  private class FENodeTypeAdapterFactory implements TypeAdapterFactory {
    public <T> TypeAdapter<T> create(Gson gson, TypeToken<T> type) {
      final TypeAdapter<T> delegate = gson.getDelegateAdapter(this, type);
      final TypeAdapter<JsonElement> elementAdapter = gson.getAdapter(JsonElement.class);
      return new TypeAdapter<T>() {
        @Override public void write(JsonWriter out, T value) throws IOException {
          JsonElement el = delegate.toJsonTree(value);
          if (el.isJsonObject() && value instanceof FENode) {
            JsonObject obj = el.getAsJsonObject();
            obj.addProperty("nodeType", value.getClass().getSimpleName());
            elementAdapter.write(out, obj);
          } else {
            elementAdapter.write(out, el);
          }
        }
        @Override public T read(JsonReader in) throws IOException {
          return delegate.read(in);
        }
      };
    }
  }
}
