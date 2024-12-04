import os
import requests

# Insira sua Steam API Key aqui
STEAM_API_KEY = "AA8827364290C8626D575B4C7B3AC7F5"
STEAM_API_URL = "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/"

# Caminho para a pasta que contém os IDs dos addons
ADDONS_FOLDER = "addons"

def get_addon_name(addon_id):
    """
    Consulta a API da Steam para obter o nome de um addon dado seu ID.
    """
    try:
        response = requests.post(STEAM_API_URL, data={
            "key": STEAM_API_KEY,
            "itemcount": 1,
            "publishedfileids[0]": addon_id
        })
        response_data = response.json()
        
        if "response" in response_data and "publishedfiledetails" in response_data["response"]:
            details = response_data["response"]["publishedfiledetails"][0]
            if details["result"] == 1:
                return details["title"]
            else:
                print(f"Erro ao buscar o addon ID {addon_id}: {details.get('result')}")
    except Exception as e:
        print(f"Erro ao acessar a API para o ID {addon_id}: {e}")
    return None

def rename_addon_folders():
    """
    Renomeia as pastas com base no nome do addon retornado pela API.
    """
    for folder_name in os.listdir(ADDONS_FOLDER):
        folder_path = os.path.join(ADDONS_FOLDER, folder_name)
        
        # Verifica se é uma pasta e se o nome é um número (ID)
        if os.path.isdir(folder_path) and folder_name.isdigit():
            print(f"Processando pasta: {folder_name}")
            addon_name = get_addon_name(folder_name)
            if addon_name:
                # Substitui caracteres inválidos para nomes de pasta
                safe_name = "".join(c for c in addon_name if c.isalnum() or c in " _-").strip()
                new_folder_path = os.path.join(ADDONS_FOLDER, safe_name)
                
                try:
                    os.rename(folder_path, new_folder_path)
                    print(f"Pasta '{folder_name}' renomeada para '{safe_name}'")
                except Exception as e:
                    print(f"Erro ao renomear a pasta '{folder_name}': {e}")
            else:
                print(f"Nome não encontrado para o addon ID {folder_name}")

if __name__ == "__main__":
    rename_addon_folders()
