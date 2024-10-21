import { cookies } from "next/headers"

export const verifyCsrfToken = (csrf: string): boolean => {
    try {
        let cookie = cookies().get('authjs.csrf-token')
        if (!cookie) {
            cookie = cookies().get('__Host-authjs.csrf-token')
            if (!cookie) {
                return false
            }
        }
        const parsedCsrfTokenAndHash = cookie.value

        if (!parsedCsrfTokenAndHash) {
            return false
        }

        const tokenHashDelimiter = parsedCsrfTokenAndHash.indexOf('|') !== -1 ? '|' : '%7C'

        const [requestToken, requestHash] = parsedCsrfTokenAndHash.split(tokenHashDelimiter)

        return requestToken == csrf
    } catch (err) {
        return false
    }
}