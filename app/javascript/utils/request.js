const json = async (response) => {
  const contentType = response.headers.get('content-type');
  if (contentType?.includes('application/json')) {
    return await response.json();
  }
};

export const request = async (url, options) => {
  try {
    const response = await fetch(url, options?.fetchOptions);
    const responseJson = await json(response);

    if (response.ok) {
      options?.onSuccess?.(responseJson);
      return responseJson;
    } else {
      if (responseJson) {
        throw responseJson.message;
      } else {
        throw response.statusText;
      }
    }
  } catch (error) {
    options?.onError?.(error);
  }
};